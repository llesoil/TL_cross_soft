#!/bin/sh

numb='283'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 3.6 --qblur 0.3 --qcomp 0.6 --vbv-init 0.9 --aq-mode 3 --b-adapt 0 --bframes 8 --crf 15 --keyint 220 --lookahead-threads 4 --min-keyint 20 --qp 30 --qpstep 5 --qpmin 1 --qpmax 69 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset veryslow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,1.0,1.4,1.4,3.6,0.3,0.6,0.9,3,0,8,15,220,4,20,30,5,1,69,48,6,2000,-1:-1,hex,show,veryslow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"