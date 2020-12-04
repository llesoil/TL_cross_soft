#!/bin/sh

numb='1695'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 3.6 --qblur 0.4 --qcomp 0.8 --vbv-init 0.5 --aq-mode 3 --b-adapt 0 --bframes 14 --crf 15 --keyint 300 --lookahead-threads 4 --min-keyint 27 --qp 30 --qpstep 3 --qpmin 1 --qpmax 68 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset placebo --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,0.0,1.2,1.2,3.6,0.4,0.8,0.5,3,0,14,15,300,4,27,30,3,1,68,28,6,1000,1:1,dia,crop,placebo,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"