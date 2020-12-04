#!/bin/sh

numb='2543'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 1.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.4 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 45 --keyint 230 --lookahead-threads 0 --min-keyint 20 --qp 50 --qpstep 3 --qpmin 3 --qpmax 65 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset slow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,2.0,1.5,1.1,1.6,0.5,0.6,0.4,2,1,4,45,230,0,20,50,3,3,65,38,2,2000,-1:-1,umh,show,slow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"