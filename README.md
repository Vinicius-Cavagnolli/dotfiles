## Applications setup
Dependencies:
- `git`
- `curl`
- `npm`
- `vim`

```bash
git clone https://github.com/Vinicius-Cavagnolli/dotfiles.git ~/.dotfiles-bkp
cd ~/.dotfiles-bkp
chmod +x install.sh
./install.sh
```

> ⚠️ The script will prompt for `sudo` to start some utilities.

## Layout setup
Dependencies:
- `konsave` [GitHub](https://github.com/prayag2/konsave)

> ⚠️ The scripts were tested within a KDE Plasma|Wayland|Kwin environment.

#### Backup
Run the backup script to save the current KDE configuration as a timestamped backup ZIP in the `konsave/profiles/` folder:

```bash
chmod + x ./konsave/backup-profile.sh
./konsave/backup-profile.sh
```

Example output file:  
`konsave/profiles/minimal-setup-2025-05-19_17-37.knsv.zip`

> ⚠️ This folder contains local konsave backups. Files here are not tracked by Git.

#### Restore
Restore a saved profile by passing the backup filename (without extension) as an argument:

```bash
chmod + x ./konsave/restore-profile.sh
./konsave/restore-profile.sh minimal-setup-2025-05-19_17-37
```
