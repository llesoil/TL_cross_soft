#!/bin/sh

numb='816'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 2.4 --qblur 0.6 --qcomp 0.8 --vbv-init 0.1 --aq-mode 2 --b-adapt 0 --bframes 4 --crf 15 --keyint 220 --lookahead-threads 2 --min-keyint 30 --qp 40 --qpstep 5 --qpmin 2 --qpmax 64 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset slower --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,0.0,1.4,1.1,2.4,0.6,0.8,0.1,2,0,4,15,220,2,30,40,5,2,64,18,3,1000,1:1,hex,show,slower,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"