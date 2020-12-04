#!/bin/sh

numb='1151'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 2.8 --qblur 0.3 --qcomp 0.9 --vbv-init 0.1 --aq-mode 3 --b-adapt 0 --bframes 14 --crf 20 --keyint 240 --lookahead-threads 1 --min-keyint 21 --qp 0 --qpstep 5 --qpmin 4 --qpmax 69 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset slower --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,1.0,1.2,1.1,2.8,0.3,0.9,0.1,3,0,14,20,240,1,21,0,5,4,69,48,5,2000,1:1,dia,show,slower,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"