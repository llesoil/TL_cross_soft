#!/bin/sh

numb='298'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 5.0 --qblur 0.5 --qcomp 0.7 --vbv-init 0.3 --aq-mode 2 --b-adapt 0 --bframes 12 --crf 50 --keyint 200 --lookahead-threads 0 --min-keyint 30 --qp 50 --qpstep 5 --qpmin 1 --qpmax 67 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset fast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,2.0,1.5,1.4,5.0,0.5,0.7,0.3,2,0,12,50,200,0,30,50,5,1,67,38,6,2000,-2:-2,dia,show,fast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"