#!/bin/bash
 
CURRENTDATE=`date +"%Y-%m-%d"`
 
echo Current Date is: ${CURRENTDATE}

BASE_PATH='.pm2/logs'
ARCHIVE_DIR='.pm2/logs/archive'



OUT_FILE='zoomSignature-out.log'
FULL_ISP_PATH=${BASE_PATH%%/}/$OUT_FILE
echo "$FULL_ISP_PATH"

if [ -f "$FULL_ISP_PATH" ]; then
	cp $FULL_ISP_PATH "${FULL_ISP_PATH%.*}"_${CURRENTDATE}.log
	echo "$FULL_ISP_PATH exists."
        echo "[`date`]"  "${FULL_ISP_PATH%.*}"_${CURRENTDATE}.log >> customLogRotate.log
	   
fi

#pm2 flush

# find $BASE_PATH -name ".log" -mtime +2 -exec ls -lat {}

if [ ! -d "$ARCHIVE_DIR" ]; then
    mkdir $ARCHIVE_DIR
fi

echo "===Archive Files===" >> customLogRotate.log
for FILENAME in $(find $BASE_PATH -type f  -name "*.log" -mtime +2 -print   ) #| sed 's/^\.\///')
do
 echo $FILENAME 
 mv $FILENAME $ARCHIVE_DIR
done

tar -czvf  ${ARCHIVE_DIR%%/}/archive.tgz *.log
