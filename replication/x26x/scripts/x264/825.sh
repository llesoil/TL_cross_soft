#!/bin/sh

numb='826'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 0.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.1 --aq-mode 0 --b-adapt 0 --bframes 6 --crf 45 --keyint 240 --lookahead-threads 2 --min-keyint 23 --qp 40 --qpstep 5 --qpmin 2 --qpmax 61 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset veryslow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,0.5,1.1,1.1,0.4,0.2,0.7,0.1,0,0,6,45,240,2,23,40,5,2,61,28,6,1000,1:1,hex,crop,veryslow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"