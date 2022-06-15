# brucelib-begin
A template for new projects using [brucelib](https://github.com/hazeycode/brucelib)

Requires [Zig 0.10.x](https://github.com/ziglang/zig)

### Initilise submodules
```
git submodule update --init
```
  
  
### Building and running
```
# Compile and run tests
zig build test

# Compile and run in debug mode
zig build run

# Compile and run with in release mode with Tracy Profiler markers enabled
zig build -Drelease-fast=true -Dztracy-enable=true run

# List all build targets and options
zig build --help
```


### Git LFS Setup (optional)
```
# Make sure git lfs is installed
git lfs install

# Set LFS tracking rules, i.e.
git lfs track "*.wav"

# commit .gitattributes
git add .gitattributes && git commit -m "setup git lfs"
```
NOTE: LFS tracking rules must be comitted before committing large files

