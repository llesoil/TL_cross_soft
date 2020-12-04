#!/bin/sh

numb='774'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 3.8 --qblur 0.2 --qcomp 0.6 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 4 --crf 45 --keyint 260 --lookahead-threads 3 --min-keyint 29 --qp 40 --qpstep 4 --qpmin 0 --qpmax 60 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset slower --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,0.5,1.6,1.1,3.8,0.2,0.6,0.3,3,1,4,45,260,3,29,40,4,0,60,38,4,2000,1:1,dia,show,slower,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"