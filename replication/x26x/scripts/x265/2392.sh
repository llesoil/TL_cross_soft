#!/bin/sh

numb='2393'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 3.0 --qblur 0.6 --qcomp 0.9 --vbv-init 0.4 --aq-mode 3 --b-adapt 1 --bframes 0 --crf 45 --keyint 230 --lookahead-threads 1 --min-keyint 29 --qp 0 --qpstep 5 --qpmin 4 --qpmax 66 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset veryslow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,3.0,1.6,1.4,3.0,0.6,0.9,0.4,3,1,0,45,230,1,29,0,5,4,66,38,2,1000,-2:-2,dia,show,veryslow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"