#!/bin/sh

numb='2522'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 4.6 --qblur 0.5 --qcomp 0.9 --vbv-init 0.0 --aq-mode 3 --b-adapt 1 --bframes 8 --crf 50 --keyint 220 --lookahead-threads 1 --min-keyint 26 --qp 20 --qpstep 3 --qpmin 3 --qpmax 67 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset slow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,2.0,1.1,1.4,4.6,0.5,0.9,0.0,3,1,8,50,220,1,26,20,3,3,67,38,5,2000,1:1,dia,show,slow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"