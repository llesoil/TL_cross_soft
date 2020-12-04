#!/bin/sh

numb='2035'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 0.2 --qblur 0.3 --qcomp 0.9 --vbv-init 0.0 --aq-mode 3 --b-adapt 0 --bframes 16 --crf 50 --keyint 240 --lookahead-threads 3 --min-keyint 28 --qp 10 --qpstep 5 --qpmin 3 --qpmax 63 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset slow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,3.0,1.3,1.4,0.2,0.3,0.9,0.0,3,0,16,50,240,3,28,10,5,3,63,48,2,1000,1:1,dia,show,slow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"