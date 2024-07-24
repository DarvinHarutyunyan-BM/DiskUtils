# DiskUtils

## Prepare
```bash
sudo cp log_disk_usage.sh /usr/local/bin/log_disk_usage.sh
chmod +x /usr/local/bin/log_disk_usage.sh

sudo cp check_disk_usage_trend.sh /usr/local/bin/check_disk_usage_trend.sh
chmod +x /usr/local/bin/check_disk_usage_trend.sh
```

## Setup
Run command and add 2 new lines in `crontab`
```bash
crontab -e
```

```
0 * * * * /usr/local/bin/log_disk_usage.sh
0 0 * * * /usr/local/bin/check_disk_usage_trend.sh
```
