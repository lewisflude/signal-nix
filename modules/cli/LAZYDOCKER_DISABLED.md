     [1mSTDIN[0m
[38;5;8m   1[0m [37m# Lazydocker Module Temporarily Disabled[0m
[38;5;8m   2[0m 
[38;5;8m   3[0m [37m## Reason[0m
[38;5;8m   4[0m [37mThe lazydocker module has been temporarily disabled due to a home-manager upstream bug where the config file is set in two places:[0m
[38;5;8m   5[0m [37m- `/nix/store/k58bj66skbw60kl5skmm7v37qrm6jv5v-source/modules/misc/xdg.nix`[0m
[38;5;8m   6[0m [37m- `/nix/store/k58bj66skbw60kl5skmm7v37qrm6jv5v-source/modules/programs/lazydocker.nix`[0m
[38;5;8m   7[0m 
[38;5;8m   8[0m [37mThis causes a conflict error:[0m
[38;5;8m   9[0m [37m```[0m
[38;5;8m  10[0m [37merror: The option `home-manager.users.lewis.home.file."/home/lewis/.config/lazydocker/config.yml".source' has conflicting definition values[0m
[38;5;8m  11[0m [37m```[0m
[38;5;8m  12[0m 
[38;5;8m  13[0m [37m## Status[0m
[38;5;8m  14[0m [37m- Module file renamed to: `lazydocker.nix.disabled`[0m
[38;5;8m  15[0m [37m- Will be re-enabled once home-manager fixes the bug[0m
[38;5;8m  16[0m [37m- The module itself is correct (ONLY sets colors)[0m
[38;5;8m  17[0m 
[38;5;8m  18[0m [37m## Workaround[0m
[38;5;8m  19[0m [37mUsers who want to theme lazydocker can:[0m
[38;5;8m  20[0m [37m1. Use `programs.lazydocker.enable = true` in their own config[0m
[38;5;8m  21[0m [37m2. Manually copy the color config from `lazydocker.nix.disabled`[0m
[38;5;8m  22[0m [37m3. Apply colors via `xdg.configFile."lazydocker/config.yml".text`[0m
[38;5;8m  23[0m 
[38;5;8m  24[0m [37m## Tracking[0m
[38;5;8m  25[0m [37m- Issue: home-manager lazydocker module conflict[0m
[38;5;8m  26[0m [37m- Date disabled: 2026-01-17[0m
