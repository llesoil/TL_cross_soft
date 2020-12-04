#!/bin/sh

numb='2432'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 2.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.8 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 30 --keyint 280 --lookahead-threads 4 --min-keyint 30 --qp 40 --qpstep 4 --qpmin 3 --qpmax 63 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset ultrafast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.0,1.5,1.0,2.6,0.6,0.7,0.8,0,1,12,30,280,4,30,40,4,3,63,48,5,1000,-2:-2,umh,show,ultrafast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"