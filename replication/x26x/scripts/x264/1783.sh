#!/bin/sh

numb='1784'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 0.6 --qblur 0.4 --qcomp 0.7 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 8 --crf 10 --keyint 300 --lookahead-threads 2 --min-keyint 30 --qp 40 --qpstep 5 --qpmin 1 --qpmax 66 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset slow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,2.0,1.2,1.2,0.6,0.4,0.7,0.3,3,1,8,10,300,2,30,40,5,1,66,38,6,2000,-2:-2,hex,crop,slow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"