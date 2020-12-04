#!/bin/sh

numb='2423'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 1.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.6 --aq-mode 0 --b-adapt 1 --bframes 16 --crf 25 --keyint 200 --lookahead-threads 4 --min-keyint 22 --qp 20 --qpstep 5 --qpmin 4 --qpmax 66 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset slower --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,1.0,1.4,1.3,1.6,0.5,0.6,0.6,0,1,16,25,200,4,22,20,5,4,66,48,6,1000,1:1,dia,show,slower,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"