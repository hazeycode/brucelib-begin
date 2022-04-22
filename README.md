# brucelib-begin
A template for new projects using [brucelib](https://github.com/hazeycode/brucelib)

### Get Zig
- Get the latest [Zig release](https://ziglang.org/download/) or use [zigup](https://github.com/marler8997/zigup) if you want to switch easily between versions of Zig.


### Initilise submodules
  ```
  git submodule update --init
  ```
  
  
### Building and running
```
# Compile and run in debug mode
zig build run

# Compile and run tests
zig build test

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

