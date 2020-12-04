#!/bin/sh

numb='1679'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 5.0 --qblur 0.5 --qcomp 0.6 --vbv-init 0.7 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 45 --keyint 210 --lookahead-threads 2 --min-keyint 23 --qp 10 --qpstep 4 --qpmin 0 --qpmax 64 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset placebo --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,2.0,1.0,1.2,5.0,0.5,0.6,0.7,0,0,8,45,210,2,23,10,4,0,64,28,5,1000,-1:-1,dia,crop,placebo,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"