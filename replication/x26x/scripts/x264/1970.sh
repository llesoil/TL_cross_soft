#!/bin/sh

numb='1971'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 1.4 --qblur 0.5 --qcomp 0.9 --vbv-init 0.4 --aq-mode 1 --b-adapt 2 --bframes 10 --crf 15 --keyint 200 --lookahead-threads 2 --min-keyint 24 --qp 40 --qpstep 4 --qpmin 0 --qpmax 67 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset slower --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.0,1.3,1.4,1.4,0.5,0.9,0.4,1,2,10,15,200,2,24,40,4,0,67,18,3,1000,-2:-2,hex,show,slower,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"