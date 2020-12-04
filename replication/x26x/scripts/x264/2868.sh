#!/bin/sh

numb='2869'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 4.8 --qblur 0.5 --qcomp 0.6 --vbv-init 0.1 --aq-mode 1 --b-adapt 1 --bframes 16 --crf 50 --keyint 260 --lookahead-threads 0 --min-keyint 24 --qp 0 --qpstep 4 --qpmin 0 --qpmax 62 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset faster --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,0.5,1.0,1.3,4.8,0.5,0.6,0.1,1,1,16,50,260,0,24,0,4,0,62,38,5,2000,-1:-1,dia,show,faster,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"