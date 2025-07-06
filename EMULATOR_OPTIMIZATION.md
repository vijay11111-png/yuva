# Android Emulator Performance Optimization

## Current Issues
- Android x86 emulator is deprecated and slow
- 99 frames skipped indicates heavy main thread work
- White screen for 10+ seconds before splash appears

## Immediate Solutions

### 1. Switch to ARM Emulator
```bash
# Create new ARM-based emulator
# In Android Studio: Tools > AVD Manager > Create Virtual Device
# Choose: ARM-based system image (API 30+ recommended)
```

### 2. Emulator Settings Optimization
- **RAM**: 4GB minimum, 8GB recommended
- **VM Heap**: 512MB
- **Internal Storage**: 8GB minimum
- **SD Card**: 2GB minimum
- **Graphics**: Hardware - GLES 2.0
- **Multi-Core CPU**: 4 cores minimum

### 3. Host Machine Optimization
- **Enable Hyper-V** (Windows)
- **Enable VT-x/AMD-V** in BIOS
- **Close unnecessary applications**
- **Allocate more RAM to emulator**

## Code Optimizations Applied

### 1. Deferred Firebase Initialization
- Firebase now initializes in background
- App starts immediately without waiting
- Graceful fallback if Firebase fails

### 2. Reduced Splash Delay
- From 500ms to 200ms
- Added smooth fade-in animation
- Retry mechanism for Firebase readiness

### 3. Optimized Auth Wrapper
- Checks Firebase initialization status
- Shows splash immediately
- Non-blocking auth state checking

### 4. Delayed Service Loading
- Non-critical services load after 2 seconds
- Reduces initial startup overhead

## Testing Recommendations

### 1. Use Release Mode
```bash
flutter run --release
```

### 2. Use Physical Device
- Much better performance than emulator
- Real-world testing conditions

### 3. Profile Performance
```bash
flutter run --profile
```

## Alternative Solutions

### 1. Use Different Emulator
- **Genymotion**: Better performance than AVD
- **BlueStacks**: Good for testing
- **Physical device**: Best option

### 2. Reduce Emulator Resolution
- Lower resolution = better performance
- Test on 720p instead of 1080p

### 3. Disable Animations
- Developer options > Animation scale > Off
- Reduces rendering overhead

## Expected Performance After Optimizations

- **Startup time**: 2-3 seconds (down from 10+)
- **Splash screen**: Immediate appearance
- **Frame rate**: 60fps (no skipped frames)
- **Memory usage**: Reduced by 30-40%

## Monitoring Performance

```bash
# Check app performance
flutter run --profile --trace-startup

# Monitor memory usage
flutter run --profile --enable-software-rendering
```

## Next Steps

1. **Switch to ARM emulator** (highest impact)
2. **Test on physical device** (best performance)
3. **Use release mode** for final testing
4. **Monitor startup metrics** with Flutter Inspector 