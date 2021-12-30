# Package Manager for Hammerspoon

Yet another package manager to simplify spoon managing.

## Installation
```bash
cd ~/.hammerspoon/Spoons
git clone https://github.com/yehvaed/SpoonsPackageManager.spoon.git
```
## Usage

```lua
local hspm = hs.loadSpoon "SpoonsPackageManager";

hspm.plug "Spoons/ReloadConfiguration" {
    fn = function(spoon)
        spoon.watch_paths = {hs.configdir .. "/init.lua"}
        spoon:start()
    end,
    repo = "Hammerspoon/Spoons"
}

hspm.boostrap()
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)