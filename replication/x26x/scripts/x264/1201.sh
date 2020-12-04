#!/bin/sh

numb='1202'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 1.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.2 --aq-mode 0 --b-adapt 1 --bframes 10 --crf 20 --keyint 280 --lookahead-threads 3 --min-keyint 25 --qp 40 --qpstep 4 --qpmin 4 --qpmax 61 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset slower --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.0,1.6,1.2,1.0,0.3,0.9,0.2,0,1,10,20,280,3,25,40,4,4,61,18,6,1000,-2:-2,dia,show,slower,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"