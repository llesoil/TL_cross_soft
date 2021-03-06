#!/bin/sh

numb='451'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 0.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.6 --aq-mode 1 --b-adapt 1 --bframes 6 --crf 0 --keyint 300 --lookahead-threads 2 --min-keyint 20 --qp 50 --qpstep 4 --qpmin 0 --qpmax 62 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset placebo --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.0,1.0,0.8,0.4,0.7,0.6,1,1,6,0,300,2,20,50,4,0,62,48,2,2000,-1:-1,umh,crop,placebo,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"