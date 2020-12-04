#!/bin/sh

numb='2637'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 1.4 --qblur 0.2 --qcomp 0.8 --vbv-init 0.8 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 5 --keyint 220 --lookahead-threads 1 --min-keyint 28 --qp 20 --qpstep 5 --qpmin 4 --qpmax 60 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset slower --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,1.0,1.2,1.3,1.4,0.2,0.8,0.8,0,1,8,5,220,1,28,20,5,4,60,48,1,2000,-2:-2,dia,show,slower,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"