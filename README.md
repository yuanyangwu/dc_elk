# dc_elk
Analyze data collection logs via ELK docker

# usage
Step 1. Extract logs. For example
```
mkdir logs
cd logs
tar xf /xxx/dc.tar
cd dc
tar xzf spa.service_dc.tgz
tar xzf spb.service_dc.tgz
```
Step 2. Import logs (1.4GB logs requires 35-min)
```
./start.sh
```
Step 3. Analyze logs in web browser
```
http://host_ip:5601/
```
Step 4. Cleanup
```
./shutdown.sh
```

