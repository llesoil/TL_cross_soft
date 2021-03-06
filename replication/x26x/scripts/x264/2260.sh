#!/bin/sh

numb='2261'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 0.6 --qblur 0.2 --qcomp 0.6 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 10 --crf 45 --keyint 250 --lookahead-threads 1 --min-keyint 28 --qp 10 --qpstep 5 --qpmin 3 --qpmax 64 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset superfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,0.0,1.6,1.0,0.6,0.2,0.6,0.3,3,1,10,45,250,1,28,10,5,3,64,18,5,1000,1:1,dia,show,superfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"