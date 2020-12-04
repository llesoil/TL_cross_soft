#!/bin/sh

numb='2060'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 1.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.0 --aq-mode 3 --b-adapt 2 --bframes 4 --crf 5 --keyint 250 --lookahead-threads 4 --min-keyint 27 --qp 30 --qpstep 3 --qpmin 4 --qpmax 67 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset slower --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.5,1.2,1.6,0.5,0.6,0.0,3,2,4,5,250,4,27,30,3,4,67,38,1,1000,1:1,dia,show,slower,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"