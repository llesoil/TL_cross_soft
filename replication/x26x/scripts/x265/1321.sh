#!/bin/sh

numb='1322'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 4.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.4 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 45 --keyint 230 --lookahead-threads 3 --min-keyint 24 --qp 30 --qpstep 4 --qpmin 0 --qpmax 69 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset ultrafast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,2.5,1.1,1.3,4.4,0.6,0.6,0.4,1,0,6,45,230,3,24,30,4,0,69,28,3,1000,1:1,umh,show,ultrafast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"