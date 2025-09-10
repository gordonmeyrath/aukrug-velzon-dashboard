// WordPress API Client for Aukrug Dashboard

const API_BASE_URL = process.env.WP_BASE_URL || 'http://localhost/wp';
const API_PREFIX = '/wp-json/aukrug/v1';

export interface ApiResponse<T> {
    data?: T;
    error?: string;
    status: number;
}

export class AukrugApiClient {
    private baseUrl: string;

    constructor(baseUrl?: string) {
        this.baseUrl = baseUrl || API_BASE_URL;
    }

    private async request<T>(
        endpoint: string,
        options: RequestInit = {}
    ): Promise<ApiResponse<T>> {
        const url = `${this.baseUrl}${API_PREFIX}${endpoint}`;

        try {
            const response = await fetch(url, {
                headers: {
                    'Content-Type': 'application/json',
                    ...options.headers,
                },
                ...options,
            });

            if (!response.ok) {
                return {
                    error: `HTTP ${response.status}: ${response.statusText}`,
                    status: response.status,
                };
            }

            const data = await response.json();
            return {
                data,
                status: response.status,
            };
        } catch (error) {
            return {
                error: error instanceof Error ? error.message : 'Unknown error',
                status: 0,
            };
        }
    }

    // Community API
    async getCommunityUsers() {
        return this.request<any[]>('/community/users');
    }

    async getCommunityGroups() {
        return this.request<any[]>('/community/groups');
    }

    async getCommunityPosts() {
        return this.request<any[]>('/community/posts');
    }

    // Reports API
    async getReports() {
        return this.request<any[]>('/reports');
    }

    async createReport(report: any) {
        return this.request<any>('/reports', {
            method: 'POST',
            body: JSON.stringify(report),
        });
    }

    async updateReport(id: string, report: any) {
        return this.request<any>(`/reports/${id}`, {
            method: 'PUT',
            body: JSON.stringify(report),
        });
    }

    // Routes API
    async getRoutes() {
        return this.request<any[]>('/routes');
    }

    async createRoute(route: any) {
        return this.request<any>('/routes', {
            method: 'POST',
            body: JSON.stringify(route),
        });
    }

    // Events API
    async getEvents() {
        return this.request<any[]>('/events');
    }

    async createEvent(event: any) {
        return this.request<any>('/events', {
            method: 'POST',
            body: JSON.stringify(event),
        });
    }

    // Downloads API
    async getDownloads() {
        return this.request<any[]>('/downloads');
    }

    async createDownload(download: any) {
        return this.request<any>('/downloads', {
            method: 'POST',
            body: JSON.stringify(download),
        });
    }

    // Notices API
    async getNotices() {
        return this.request<any[]>('/notices');
    }

    async createNotice(notice: any) {
        return this.request<any>('/notices', {
            method: 'POST',
            body: JSON.stringify(notice),
        });
    }

    // Geocaching API
    async getGeocaches() {
        return this.request<any[]>('/geocaching');
    }

    // Marketplace API
    async getMarketplaceListings() {
        return this.request<any[]>('/marketplace');
    }

    // Verification API
    async getVerificationRequests() {
        return this.request<any[]>('/verification');
    }

    async approveVerification(id: string) {
        return this.request<any>(`/verification/${id}/approve`, {
            method: 'POST',
        });
    }

    // Sync API
    async syncData() {
        return this.request<any>('/sync', {
            method: 'POST',
        });
    }

    async getSyncStatus() {
        return this.request<any>('/sync/status');
    }
}

// Default client instance
export const apiClient = new AukrugApiClient();

// React Hook for API calls
export function useApi() {
    return apiClient;
}
