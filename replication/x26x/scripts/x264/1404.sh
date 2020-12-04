#!/bin/sh

numb='1405'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 4.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.7 --aq-mode 1 --b-adapt 1 --bframes 14 --crf 5 --keyint 250 --lookahead-threads 3 --min-keyint 20 --qp 50 --qpstep 4 --qpmin 0 --qpmax 60 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset slower --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.3,1.1,4.4,0.3,0.8,0.7,1,1,14,5,250,3,20,50,4,0,60,38,3,2000,1:1,umh,show,slower,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"