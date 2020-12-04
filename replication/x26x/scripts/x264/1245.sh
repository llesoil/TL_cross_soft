#!/bin/sh

numb='1246'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 4.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 15 --keyint 210 --lookahead-threads 4 --min-keyint 21 --qp 50 --qpstep 4 --qpmin 1 --qpmax 67 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset faster --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,1.0,1.6,1.3,4.4,0.2,0.7,0.1,1,2,12,15,210,4,21,50,4,1,67,38,2,1000,1:1,hex,show,faster,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"