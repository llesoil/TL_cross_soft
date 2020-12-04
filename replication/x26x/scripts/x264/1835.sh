#!/bin/sh

numb='1836'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.1 --psy-rd 1.6 --qblur 0.4 --qcomp 0.9 --vbv-init 0.3 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 10 --keyint 300 --lookahead-threads 0 --min-keyint 30 --qp 20 --qpstep 5 --qpmin 4 --qpmax 63 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset faster --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.5,1.2,1.1,1.6,0.4,0.9,0.3,3,2,14,10,300,0,30,20,5,4,63,48,2,1000,1:1,hex,show,faster,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"