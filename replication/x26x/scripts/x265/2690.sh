#!/bin/sh

numb='2691'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 2.6 --qblur 0.3 --qcomp 0.6 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 25 --keyint 250 --lookahead-threads 4 --min-keyint 25 --qp 20 --qpstep 5 --qpmin 4 --qpmax 66 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset ultrafast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,1.5,1.6,1.4,2.6,0.3,0.6,0.8,2,0,8,25,250,4,25,20,5,4,66,38,2,2000,-1:-1,umh,show,ultrafast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"