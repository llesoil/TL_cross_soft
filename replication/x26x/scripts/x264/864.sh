#!/bin/sh

numb='865'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 1.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.8 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 40 --keyint 300 --lookahead-threads 1 --min-keyint 20 --qp 10 --qpstep 5 --qpmin 3 --qpmax 64 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset veryfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,0.0,1.1,1.2,1.4,0.3,0.8,0.8,0,0,16,40,300,1,20,10,5,3,64,28,1,2000,1:1,dia,show,veryfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"