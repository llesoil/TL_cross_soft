#!/bin/sh

numb='1854'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 0.2 --qblur 0.4 --qcomp 0.6 --vbv-init 0.0 --aq-mode 2 --b-adapt 0 --bframes 12 --crf 45 --keyint 210 --lookahead-threads 2 --min-keyint 28 --qp 10 --qpstep 4 --qpmin 0 --qpmax 64 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset veryslow --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,0.5,1.5,1.3,0.2,0.4,0.6,0.0,2,0,12,45,210,2,28,10,4,0,64,18,6,2000,-1:-1,dia,show,veryslow,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"