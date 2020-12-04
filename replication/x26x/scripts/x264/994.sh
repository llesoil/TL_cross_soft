#!/bin/sh

numb='995'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 4.2 --qblur 0.6 --qcomp 0.9 --vbv-init 0.5 --aq-mode 0 --b-adapt 2 --bframes 16 --crf 0 --keyint 280 --lookahead-threads 0 --min-keyint 30 --qp 50 --qpstep 3 --qpmin 3 --qpmax 66 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset slower --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,3.0,1.0,1.3,4.2,0.6,0.9,0.5,0,2,16,0,280,0,30,50,3,3,66,38,1,2000,-1:-1,dia,show,slower,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"