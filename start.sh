if [ "$#" -ne 1 ]; then
  echo "Usage: start.sh <dc_log_relative_path_to_this_dir>"
  echo "Example: start.sh logs/auto_triage__Unity_400_service_data_FNM00153500391_2016-08-30_09_51_44"
  exit 1
fi

echo "Launch ELK"
docker run -p 5601:5601 -p 9200:9200 -p 5044:5044 -p 5000:5000 -v $( pwd ):/dc_elk -d -e ES_HEAP_SIZE="2g" -e LS_HEAP_SIZE="1g" --name elk sebp/elk

echo "Wait for ELK launch completion"
sleep 10

echo "Import DC logs at $1"
docker exec -it elk /dc_elk/import_dc.sh /dc_elk/$1

