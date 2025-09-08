/**
 * Aukrug Community Admin JavaScript
 * Enhanced admin interface functionality
 */

(function ($) {
    'use strict';

    const AukrugCommunityAdmin = {

        init: function () {
            this.initTabSwitching();
            this.initModals();
            this.initAjaxActions();
            this.initDataTables();
            this.initCharts();
            this.initFormValidation();
            this.initSearchAndFilters();
            this.initNotifications();
        },

        initTabSwitching: function () {
            $('.nav-tab').on('click', function (e) {
                e.preventDefault();

                const targetTab = $(this).attr('href').substring(1);

                // Update active tab
                $('.nav-tab').removeClass('nav-tab-active');
                $(this).addClass('nav-tab-active');

                // Show corresponding content
                $('.tab-content').removeClass('active');
                $('#' + targetTab).addClass('active');

                // Save active tab in localStorage
                localStorage.setItem('aukrug_active_tab', targetTab);
            });

            // Restore active tab on page load
            const activeTab = localStorage.getItem('aukrug_active_tab');
            if (activeTab && $('#' + activeTab).length) {
                $('a[href="#' + activeTab + '"]').click();
            }
        },

        initModals: function () {
            // Open modals
            $('#create-group, #create-event, #add-user').on('click', function (e) {
                e.preventDefault();
                const modalId = $(this).data('modal') || 'group-modal';
                $('#' + modalId).fadeIn(300);
            });

            // Close modals
            $('.aukrug-modal').on('click', function (e) {
                if (e.target === this) {
                    $(this).fadeOut(300);
                }
            });

            $('.modal-close, .button[onclick*="hide"]').on('click', function () {
                $('.aukrug-modal').fadeOut(300);
            });

            // ESC key to close modals
            $(document).on('keyup', function (e) {
                if (e.keyCode === 27) {
                    $('.aukrug-modal').fadeOut(300);
                }
            });
        },

        initAjaxActions: function () {
            const self = this;

            // Generic AJAX handler
            $(document).on('click', '[data-action]', function (e) {
                e.preventDefault();

                const $button = $(this);
                const action = $button.data('action');
                const itemId = $button.data('id');
                const confirmMessage = $button.data('confirm');

                if (confirmMessage && !confirm(confirmMessage)) {
                    return;
                }

                self.performAjaxAction(action, {
                    id: itemId,
                    button: $button
                });
            });

            // Form submissions
            $('#create-group-form, #create-event-form').on('submit', function (e) {
                e.preventDefault();

                const formData = new FormData(this);
                const action = $(this).attr('id').replace('-form', '').replace('-', '_');

                self.performAjaxAction(action, {
                    formData: formData,
                    form: $(this)
                });
            });

            // Bulk actions
            $('#bulk-verify-users, #bulk-delete-posts').on('click', function () {
                const checkedItems = $('.bulk-checkbox:checked');
                if (checkedItems.length === 0) {
                    alert('Please select items to perform bulk action.');
                    return;
                }

                const action = $(this).attr('id').replace('bulk-', '');
                const ids = checkedItems.map(function () {
                    return $(this).val();
                }).get();

                if (confirm(`Are you sure you want to ${action} ${ids.length} items?`)) {
                    self.performAjaxAction('bulk_' + action, { ids: ids });
                }
            });
        },

        performAjaxAction: function (action, options = {}) {
            const $button = options.button;
            const $form = options.form;

            // Show loading state
            if ($button) {
                $button.prop('disabled', true);
                const originalText = $button.text();
                $button.text(aukrugCommunity.loading);
                $button.data('original-text', originalText);
            }

            const ajaxData = {
                action: 'aukrug_community_action',
                community_action: action,
                nonce: aukrugCommunity.nonce
            };

            // Add form data if provided
            if (options.formData) {
                for (let [key, value] of options.formData.entries()) {
                    ajaxData[key] = value;
                }
            }

            // Add other options
            Object.assign(ajaxData, options);

            $.post(aukrugCommunity.ajaxUrl, ajaxData)
                .done(function (response) {
                    if (response.success) {
                        // Handle successful response
                        if (response.data.message) {
                            AukrugCommunityAdmin.showNotification(response.data.message, 'success');
                        }

                        if (response.data.html) {
                            // Update content
                            const targetContainer = response.data.container || '#main-content';
                            $(targetContainer).html(response.data.html);
                        }

                        if (response.data.reload) {
                            location.reload();
                        }

                        if (response.data.redirect) {
                            window.location.href = response.data.redirect;
                        }

                        // Close modal if form was in modal
                        if ($form && $form.closest('.aukrug-modal').length) {
                            $form.closest('.aukrug-modal').fadeOut(300);
                            $form[0].reset();
                        }

                    } else {
                        AukrugCommunityAdmin.showNotification(
                            response.data || 'An error occurred',
                            'error'
                        );
                    }
                })
                .fail(function (xhr, status, error) {
                    AukrugCommunityAdmin.showNotification(
                        'Network error: ' + error,
                        'error'
                    );
                })
                .always(function () {
                    // Restore button state
                    if ($button) {
                        $button.prop('disabled', false);
                        $button.text($button.data('original-text'));
                    }
                });
        },

        initDataTables: function () {
            // Initialize sortable tables
            $('.aukrug-data-table').each(function () {
                const $table = $(this);

                // Add sorting functionality
                $table.find('th[data-sort]').addClass('sortable').on('click', function () {
                    const column = $(this).data('sort');
                    const currentOrder = $(this).data('order') || 'asc';
                    const newOrder = currentOrder === 'asc' ? 'desc' : 'asc';

                    AukrugCommunityAdmin.sortTable($table, column, newOrder);

                    // Update sort indicators
                    $table.find('th').removeClass('sort-asc sort-desc');
                    $(this).addClass('sort-' + newOrder).data('order', newOrder);
                });
            });

            // Initialize pagination
            this.initPagination();
        },

        sortTable: function ($table, column, order) {
            const $tbody = $table.find('tbody');
            const rows = $tbody.find('tr').toArray();

            rows.sort(function (a, b) {
                const aValue = $(a).find(`[data-sort-value="${column}"]`).text().trim();
                const bValue = $(b).find(`[data-sort-value="${column}"]`).text().trim();

                // Try to parse as numbers
                const aNum = parseFloat(aValue);
                const bNum = parseFloat(bValue);

                if (!isNaN(aNum) && !isNaN(bNum)) {
                    return order === 'asc' ? aNum - bNum : bNum - aNum;
                }

                // String comparison
                return order === 'asc'
                    ? aValue.localeCompare(bValue)
                    : bValue.localeCompare(aValue);
            });

            $tbody.empty().append(rows);
        },

        initPagination: function () {
            $('.pagination-links a').on('click', function (e) {
                e.preventDefault();

                const page = $(this).data('page');
                const container = $(this).closest('.pagination-container').data('container');

                AukrugCommunityAdmin.loadPage(page, container);
            });
        },

        loadPage: function (page, container) {
            const currentUrl = new URL(window.location);
            currentUrl.searchParams.set('paged', page);

            // Update URL without page reload
            history.pushState({}, '', currentUrl);

            // Load new content via AJAX
            this.performAjaxAction('load_page', {
                page: page,
                container: container
            });
        },

        initCharts: function () {
            // Chart color scheme
            const colors = {
                primary: '#2196F3',
                secondary: '#4CAF50',
                warning: '#FF9800',
                danger: '#F44336',
                info: '#9C27B0'
            };

            // Initialize charts with Chart.js if available
            if (typeof Chart !== 'undefined') {
                Chart.defaults.font.family = '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif';
                Chart.defaults.plugins.legend.position = 'bottom';
                Chart.defaults.elements.line.tension = 0.4;
                Chart.defaults.elements.point.radius = 6;
                Chart.defaults.elements.point.hoverRadius = 8;
            }

            // Auto-refresh charts
            setInterval(() => {
                this.refreshCharts();
            }, 300000); // Refresh every 5 minutes
        },

        refreshCharts: function () {
            // Refresh chart data via AJAX
            this.performAjaxAction('refresh_charts', {
                success: function (data) {
                    // Update chart data
                    if (window.engagementChart && data.engagement) {
                        window.engagementChart.data.datasets[0].data = data.engagement;
                        window.engagementChart.update();
                    }

                    if (window.contentChart && data.content) {
                        window.contentChart.data.datasets[0].data = data.content;
                        window.contentChart.update();
                    }
                }
            });
        },

        initFormValidation: function () {
            // Real-time form validation
            $('form').each(function () {
                const $form = $(this);

                $form.find('input[required], textarea[required], select[required]').on('blur', function () {
                    AukrugCommunityAdmin.validateField($(this));
                });

                $form.on('submit', function (e) {
                    let isValid = true;

                    $form.find('input[required], textarea[required], select[required]').each(function () {
                        if (!AukrugCommunityAdmin.validateField($(this))) {
                            isValid = false;
                        }
                    });

                    if (!isValid) {
                        e.preventDefault();
                        AukrugCommunityAdmin.showNotification(
                            'Please fill in all required fields correctly.',
                            'error'
                        );
                    }
                });
            });
        },

        validateField: function ($field) {
            const value = $field.val().trim();
            const type = $field.attr('type');
            let isValid = true;
            let message = '';

            // Remove existing validation classes
            $field.removeClass('field-valid field-invalid');
            $field.siblings('.field-error').remove();

            // Required field check
            if ($field.attr('required') && !value) {
                isValid = false;
                message = 'This field is required.';
            }

            // Email validation
            if (type === 'email' && value) {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(value)) {
                    isValid = false;
                    message = 'Please enter a valid email address.';
                }
            }

            // URL validation
            if (type === 'url' && value) {
                try {
                    new URL(value);
                } catch {
                    isValid = false;
                    message = 'Please enter a valid URL.';
                }
            }

            // Add validation classes and messages
            $field.addClass(isValid ? 'field-valid' : 'field-invalid');

            if (!isValid && message) {
                $field.after(`<div class="field-error">${message}</div>`);
            }

            return isValid;
        },

        initSearchAndFilters: function () {
            let searchTimeout;

            // Real-time search
            $('#user-search, #group-search, #event-search').on('input', function () {
                clearTimeout(searchTimeout);
                const $input = $(this);
                const searchTerm = $input.val().trim();
                const searchType = $input.attr('id').replace('-search', '');

                searchTimeout = setTimeout(() => {
                    AukrugCommunityAdmin.performSearch(searchType, searchTerm);
                }, 500);
            });

            // Filter changes
            $('select[id$="-filter"]').on('change', function () {
                const filterType = $(this).attr('id').replace('-filter', '');
                const filterValue = $(this).val();

                AukrugCommunityAdmin.applyFilter(filterType, filterValue);
            });

            // Clear filters
            $('.clear-filters').on('click', function () {
                $('select[id$="-filter"]').val('');
                $('input[id$="-search"]').val('');
                $(this).trigger('change');
            });
        },

        performSearch: function (type, term) {
            this.performAjaxAction('search_' + type, {
                search_term: term,
                container: `#${type}s-table-container`
            });
        },

        applyFilter: function (type, value) {
            this.performAjaxAction('filter_' + type, {
                filter_value: value,
                container: `#${type}s-table-container`
            });
        },

        initNotifications: function () {
            // Create notification container if it doesn't exist
            if (!$('#aukrug-notifications').length) {
                $('body').append('<div id="aukrug-notifications"></div>');
            }

            // Auto-hide notifications after 5 seconds
            setTimeout(() => {
                $('.aukrug-notification').fadeOut(300, function () {
                    $(this).remove();
                });
            }, 5000);
        },

        showNotification: function (message, type = 'info') {
            const notification = $(`
                <div class="aukrug-notification notification-${type}">
                    <div class="notification-content">
                        <span class="notification-icon"></span>
                        <span class="notification-message">${message}</span>
                        <button class="notification-close" type="button">&times;</button>
                    </div>
                </div>
            `);

            $('#aukrug-notifications').append(notification);

            // Animate in
            notification.addClass('show');

            // Auto-hide after 5 seconds
            setTimeout(() => {
                notification.removeClass('show');
                setTimeout(() => notification.remove(), 300);
            }, 5000);

            // Manual close
            notification.find('.notification-close').on('click', function () {
                notification.removeClass('show');
                setTimeout(() => notification.remove(), 300);
            });
        },

        // Utility functions
        formatNumber: function (num) {
            return new Intl.NumberFormat().format(num);
        },

        formatDate: function (date) {
            return new Intl.DateTimeFormat('de-DE').format(new Date(date));
        },

        formatTime: function (date) {
            return new Intl.DateTimeFormat('de-DE', {
                hour: '2-digit',
                minute: '2-digit'
            }).format(new Date(date));
        },

        // Data export functionality
        exportData: function (type, format = 'csv') {
            const form = $('<form>', {
                method: 'POST',
                action: aukrugCommunity.ajaxUrl
            });

            form.append($('<input>', {
                type: 'hidden',
                name: 'action',
                value: 'aukrug_export_data'
            }));

            form.append($('<input>', {
                type: 'hidden',
                name: 'export_type',
                value: type
            }));

            form.append($('<input>', {
                type: 'hidden',
                name: 'export_format',
                value: format
            }));

            form.append($('<input>', {
                type: 'hidden',
                name: 'nonce',
                value: aukrugCommunity.nonce
            }));

            $('body').append(form);
            form.submit();
            form.remove();
        }
    };

    // Initialize when document is ready
    $(document).ready(function () {
        AukrugCommunityAdmin.init();
    });

    // Make available globally
    window.AukrugCommunityAdmin = AukrugCommunityAdmin;

})(jQuery);

// Additional notification styles (inject into head)
const notificationStyles = `
<style>
#aukrug-notifications {
    position: fixed;
    top: 32px;
    right: 20px;
    z-index: 999999;
    max-width: 400px;
}

.aukrug-notification {
    margin-bottom: 10px;
    opacity: 0;
    transform: translateX(100%);
    transition: all 0.3s ease;
}

.aukrug-notification.show {
    opacity: 1;
    transform: translateX(0);
}

.notification-content {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 16px;
    border-radius: 8px;
    box-shadow: 0 4px 16px rgba(0,0,0,0.15);
    background: white;
    border-left: 4px solid #2196F3;
}

.notification-success .notification-content {
    border-left-color: #4CAF50;
}

.notification-error .notification-content {
    border-left-color: #F44336;
}

.notification-warning .notification-content {
    border-left-color: #FF9800;
}

.notification-icon:before {
    font-family: 'dashicons';
    font-size: 18px;
    content: '\\f348';
    color: #2196F3;
}

.notification-success .notification-icon:before {
    content: '\\f147';
    color: #4CAF50;
}

.notification-error .notification-icon:before {
    content: '\\f534';
    color: #F44336;
}

.notification-warning .notification-icon:before {
    content: '\\f534';
    color: #FF9800;
}

.notification-message {
    flex: 1;
    font-size: 14px;
    color: #1e1e1e;
}

.notification-close {
    background: none;
    border: none;
    font-size: 18px;
    color: #666;
    cursor: pointer;
    padding: 0;
    line-height: 1;
}

.notification-close:hover {
    color: #333;
}

.field-error {
    color: #F44336;
    font-size: 12px;
    margin-top: 4px;
}

.field-invalid {
    border-color: #F44336 !important;
}

.field-valid {
    border-color: #4CAF50 !important;
}
</style>
`;

document.head.insertAdjacentHTML('beforeend', notificationStyles);
