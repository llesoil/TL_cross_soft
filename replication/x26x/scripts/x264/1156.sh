#!/bin/sh

numb='1157'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 5.0 --qblur 0.5 --qcomp 0.8 --vbv-init 0.0 --aq-mode 0 --b-adapt 2 --bframes 8 --crf 50 --keyint 290 --lookahead-threads 2 --min-keyint 30 --qp 0 --qpstep 5 --qpmin 3 --qpmax 66 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset slow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.5,1.5,1.2,5.0,0.5,0.8,0.0,0,2,8,50,290,2,30,0,5,3,66,48,4,1000,1:1,dia,crop,slow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"