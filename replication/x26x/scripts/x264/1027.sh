#!/bin/sh

numb='1028'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 1.8 --qblur 0.3 --qcomp 0.9 --vbv-init 0.8 --aq-mode 0 --b-adapt 1 --bframes 0 --crf 15 --keyint 230 --lookahead-threads 1 --min-keyint 21 --qp 40 --qpstep 5 --qpmin 4 --qpmax 62 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset veryfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,3.0,1.1,1.0,1.8,0.3,0.9,0.8,0,1,0,15,230,1,21,40,5,4,62,38,2,2000,1:1,dia,crop,veryfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"