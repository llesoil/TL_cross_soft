#!/bin/sh

numb='1261'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --intra-refresh --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 4.8 --qblur 0.6 --qcomp 0.9 --vbv-init 0.6 --aq-mode 2 --b-adapt 1 --bframes 8 --crf 25 --keyint 290 --lookahead-threads 0 --min-keyint 20 --qp 0 --qpstep 5 --qpmin 4 --qpmax 62 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset veryslow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,--intra-refresh,None,--slow-firstpass,--weightb,0.5,1.6,1.3,4.8,0.6,0.9,0.6,2,1,8,25,290,0,20,0,5,4,62,48,1,2000,1:1,dia,crop,veryslow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"