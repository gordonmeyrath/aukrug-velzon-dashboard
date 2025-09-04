feat: Complete map integration with interactive markers and navigation

🗺️ MAJOR MILESTONE: Full Map Integration System

## 🎯 Features Implemented:

### Core Map Infrastructure:

- ✅ AukrugMap widget with OpenStreetMap integration
- ✅ MapMarkerFactory for smart marker generation
- ✅ Interactive zoom controls and region constraints
- ✅ Material Design 3 integration with Cards and shadows

### Places Integration:

- ✅ PlacesMapPage with interactive place markers
- ✅ Category-based color coding (dining, nature, accommodation, etc.)
- ✅ Tap-to-show detail cards with place information
- ✅ Seamless navigation from Places List → Map view

### Events Integration:

- ✅ EventsMapPage with event location markers
- ✅ Extended Event model with latitude/longitude fields
- ✅ GPS coordinates added to fixture data
- ✅ Automatic filtering for events with location data
- ✅ Event detail cards with date/time/price information

### Technical Achievements:

- ✅ flutter_map + latlong2 dependency integration
- ✅ Code generation pipeline updated (101 outputs)
- ✅ Responsive marker sizing and selection states
- ✅ Clean architecture: widgets/domain/data separation
- ✅ All tests passing with 18 deprecation warnings only

## 📊 Statistics:

- Total new files created: 15+
- Lines of code added: 1000+
- Features completed: Events, Notices, Reports, Maps
- Test coverage: All passing
- Architecture: Feature-first with clean separation

## 🚀 User Experience:

- Both tourist and resident audiences can now:
  - Browse places and events in modern list views
  - Switch to interactive map views with one tap
  - See categorized, color-coded markers
  - Tap markers for detailed information cards
  - Navigate seamlessly between list and map views

## 🔧 Technical Foundation:

- Robust offline-first data loading
- Riverpod state management throughout
- Freezed models with JSON serialization
- GoRouter navigation with shell architecture
- Material 3 design system consistency
- Localization support (German/English)

## 📍 Geographic Data:

- Realistic Aukrug coordinates (54.13°N, 9.88°E)
- Bounded map view for relevant area
- Strategic marker placement for key locations

This milestone represents a fully functional MVP with:
✓ Complete navigation system
✓ Working features for both audiences  
✓ Interactive maps with real location data
✓ Modern, responsive UI/UX
✓ Solid technical foundation for future features

Ready for next development phase: Enhanced features and performance optimization.
