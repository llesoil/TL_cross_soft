#!/bin/sh

numb='1555'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 3.6 --qblur 0.3 --qcomp 0.8 --vbv-init 0.8 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 35 --keyint 250 --lookahead-threads 4 --min-keyint 23 --qp 40 --qpstep 3 --qpmin 1 --qpmax 60 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset veryslow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,3.0,1.1,1.2,3.6,0.3,0.8,0.8,0,0,16,35,250,4,23,40,3,1,60,18,1,1000,1:1,dia,show,veryslow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"