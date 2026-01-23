# 🎯 NewsNest Master Agent Coordination File

## Purpose
This is the **master coordination file** for implementing NewsNest. It guides agents through the implementation process and directs them to feature-specific agent instructions.

---

## 📋 Implementation Workflow

### Phase Order
Follow this exact order for implementation:

```
1. Dependencies & Setup     (Foundation)
2. Core Layer              (Shared utilities)
3. Data Layer              (Models & Repositories)
4. Providers               (State Management)
5. Routing                 (Navigation)
6. Shared Widgets          (Reusable UI)
7. Features                (In order below)
```

---

## 🎨 Feature Implementation Order

When implementing features, **ALWAYS** follow this order:

### Priority Order
1. **Splash** → Entry point, simplest feature
2. **Onboarding** → First-time user experience
3. **Home Feed** → Core functionality
4. **Article Detail** → Reading experience
5. **Bookmarks** → Saving content
6. **Local News** → Hyperlocal feature
7. **Search** → Discovery feature
8. **Settings** → User preferences

---

## 📖 Feature-Specific Agent Instructions

> **⚠️ CRITICAL RULE**: Before implementing ANY feature, you MUST read the feature-specific `AGENT.md` file located in that feature's folder.

### Feature Agent Files Location Map

| Feature | Agent File Path | Read Before Implementing |
|---------|----------------|--------------------------|
| **Splash** | `lib/features/splash/AGENT.md` | ✅ MUST READ |
| **Onboarding** | `lib/features/onboarding/AGENT.md` | ✅ MUST READ |
| **Home Feed** | `lib/features/home/AGENT.md` | ✅ MUST READ |
| **Article Detail** | `lib/features/article/AGENT.md` | ✅ MUST READ |
| **Local News** | `lib/features/local_news/AGENT.md` | ✅ MUST READ |
| **Bookmarks** | `lib/features/bookmarks/AGENT.md` | ✅ MUST READ |
| **Search** | `lib/features/search/AGENT.md` | ✅ MUST READ |
| **Settings** | `lib/features/settings/AGENT.md` | ✅ MUST READ |

---

## 🔄 Implementation Pattern for Each Feature

For **EVERY** feature, follow this exact pattern:

### Step 1: Read Agent Instructions
```bash
# Example for Splash feature
Read: lib/features/splash/AGENT.md
```

### Step 2: Understand Requirements
- Review acceptance criteria
- Check UI specifications
- Note dependencies
- Review code examples

### Step 3: Implement Following Agent Guidelines
- Use the exact structure from AGENT.md
- Follow naming conventions from AGENTS.md
- Implement state management as specified
- Create all required widgets

### Step 4: Test Against Checklist
- Use the testing checklist from AGENT.md
- Verify all acceptance criteria
- Check common pitfalls

### Step 5: Move to Next Feature
- Only proceed when current feature is complete
- Dependencies must be implemented first

---

## 🧩 Core Layer Components

Before implementing features, ensure these are complete:

### Constants (`lib/core/constants/`)
- [x] `api_constants.dart` - API configuration
- [x] `app_constants.dart` - App-wide constants
- [x] `storage_keys.dart` - Storage keys
- [x] `categories.dart` - News categories
- [x] `cities.dart` - Indian cities

### Theme (`lib/core/theme/`)
- [x] `app_colors.dart` - Color palette
- [x] `app_text_styles.dart` - Typography
- [x] `app_theme.dart` - Theme configuration

### Network (`lib/core/network/`)
- [x] `api_client.dart` - Dio setup
- [x] `api_exceptions.dart` - Custom exceptions
- [x] `network_info.dart` - Connectivity

### Utils & Extensions (`lib/core/utils/`, `lib/core/extensions/`)
- [x] `date_utils.dart` - Date formatting
- [x] `validators.dart` - Input validation
- [x] `helpers.dart` - General helpers
- [x] `context_extensions.dart` - BuildContext extensions
- [x] `string_extensions.dart` - String extensions
- [x] `date_extensions.dart` - DateTime extensions

---

## 📊 Data Layer Components

### Models (`lib/data/models/`)
- [x] `article_model.dart` - Article data model
- [x] `category_model.dart` - Category model
- [x] `user_preferences_model.dart` - User preferences

### Data Sources (`lib/data/datasources/`)
- [x] `remote/news_api_service.dart` - NewsData.io API
- [x] `local/preferences_local_source.dart` - SharedPreferences
- [x] `local/bookmark_local_source.dart` - Hive storage

### Repositories (`lib/data/repositories/`)
- [x] `news_repository.dart` - News data
- [x] `preferences_repository.dart` - User preferences
- [x] `bookmark_repository.dart` - Bookmarks

---

## 🔌 State Management (Providers)

All providers must be in `lib/providers/`:

- [x] `theme_provider.dart` - Theme state
- [x] `user_preferences_provider.dart` - User preferences
- [x] `news_feed_provider.dart` - News feed
- [x] `local_news_provider.dart` - Local news
- [x] `bookmark_provider.dart` - Bookmarks
- [x] `onboarding_provider.dart` - Onboarding flow

---

## 🛣️ Routing

### Router Configuration (`lib/routes/app_router.dart`)
Define all routes using GoRouter:
- `/` - Splash
- `/welcome` - Welcome screen
- `/interests` - Interest picker
- `/city` - City selector
- `/onboarding-complete` - Onboarding done
- `/home` - Main feed
- `/article/:id` - Article detail
- `/bookmarks` - Saved articles
- `/local-news` - Local news
- `/search` - Search
- `/settings` - Settings

---

## 🧱 Shared Widgets

Create reusable widgets in `lib/shared/widgets/`:

- [x] `custom_app_bar.dart` - Consistent app bar
- [x] `loading_widget.dart` - Shimmer loader
- [x] `error_widget.dart` - Error display
- [x] `empty_state_widget.dart` - Empty state
- [x] `primary_button.dart` - Button component

---

## ✅ Quality Checklist

Before marking any feature as complete, verify:

### Code Quality
- [ ] Follows naming conventions from AGENTS.md
- [ ] No hardcoded strings (use constants)
- [ ] No hardcoded colors (use theme)
- [ ] Proper error handling
- [ ] No unused imports
- [ ] No `print()` statements (use `debugPrint`)

### State Management
- [ ] Uses appropriate Provider type
- [ ] Proper `notifyListeners()` usage
- [ ] No memory leaks (dispose properly)
- [ ] Uses `Selector` for optimization

### UI/UX
- [ ] Responsive design
- [ ] Loading states implemented
- [ ] Error states implemented
- [ ] Empty states implemented
- [ ] Smooth animations
- [ ] Works in light and dark mode

### Testing
- [ ] All acceptance criteria met
- [ ] Testing checklist completed
- [ ] Common pitfalls avoided
- [ ] Manual testing performed

---

## 🚨 Critical Rules

### MUST DO:
1. ✅ **Read feature AGENT.md before implementing**
2. ✅ **Follow the implementation order**
3. ✅ **Use Provider for state management** (not setState alone)
4. ✅ **Implement all states** (loading, error, empty, loaded)
5. ✅ **Follow AGENTS.md guidelines** for architecture
6. ✅ **Test before moving to next feature**

### NEVER DO:
1. ❌ **Skip reading feature AGENT.md**
2. ❌ **Implement features out of order** (dependencies!)
3. ❌ **Hardcode values** (colors, strings, URLs)
4. ❌ **Mix setState with Provider** (use Provider consistently)
5. ❌ **Forget to dispose** (ScrollControllers, TextEditingControllers)
6. ❌ **Skip error handling**

---

## 📚 Reference Documents

### Always Refer To:
1. **AGENTS.md** - Overall architecture and coding standards
2. **NN_Roadmap.md** - Product requirements and specifications
3. **implementation_plan.md** - Detailed implementation plan
4. **task.md** - Current progress tracking

### Feature-Specific:
For each feature, refer to its `AGENT.md` file in the feature folder.

---

## 🔄 Dependency Chart

```
┌─────────────────────────────────────────┐
│           Dependencies Setup            │
│        (pubspec.yaml, Hive init)        │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│            Core Layer                   │
│  (Constants, Theme, Network, Utils)     │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│            Data Layer                   │
│   (Models, DataSources, Repositories)   │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│           Providers                     │
│      (State Management Layer)           │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│     Routing + Shared Widgets            │
│    (GoRouter, Reusable Components)      │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│           Features                      │
│  (Screens + Widgets, in order)          │
└─────────────────────────────────────────┘
```

---

## 📝 Implementation Status Tracking

Track progress in `task.md` artifact:
- Use `[ ]` for uncompleted
- Use `[/]` for in-progress
- Use `[x]` for completed

Update after completing each component.

---

## 🎓 Agent Best Practices

### When Starting New Feature:
1. Call `view_file` on feature's `AGENT.md`
2. Review all sections thoroughly
3. Check dependencies are implemented
4. Create folder structure if needed
5. Implement following exact patterns shown

### During Implementation:
1. Follow code structure from AGENT.md
2. Use constants from core layer
3. Use theme colors/styles
4. Implement all states
5. Add error handling
6. Use proper Provider patterns

### After Implementation:
1. Run through testing checklist
2. Verify acceptance criteria
3. Check for common pitfalls
4. Update task.md
5. Test in both themes

---

## 🎯 Success Criteria

A feature is **COMPLETE** when:
- ✅ All files from AGENT.md created
- ✅ All acceptance criteria met
- ✅ All states implemented (loading, error, empty, loaded)
- ✅ Testing checklist passed
- ✅ Works in light and dark mode
- ✅ No errors or warnings
- ✅ Follows all coding standards
- ✅ Properly integrated with providers
- ✅ Navigation works correctly

---

## 📞 Support & Reference

### Main Documents:
- **Architecture**: `.agent/rules/AGENTS.md`
- **Product Spec**: `.agent/workflows/NN_Roadmap.md`
- **This File**: `.agent/rules/MASTER_AGENT.md`

### Feature Guides:
All in `lib/features/{feature_name}/AGENT.md`

---

**Remember**: The feature-specific AGENT.md files contain the exact code patterns, UI specs, and implementation details. This master file just coordinates the workflow. **Always read the feature AGENT.md before implementing!**
