#!/bin/sh

numb='2983'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 4.2 --qblur 0.6 --qcomp 0.7 --vbv-init 0.3 --aq-mode 1 --b-adapt 0 --bframes 8 --crf 20 --keyint 280 --lookahead-threads 1 --min-keyint 27 --qp 0 --qpstep 3 --qpmin 3 --qpmax 60 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset fast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,3.0,1.1,1.1,4.2,0.6,0.7,0.3,1,0,8,20,280,1,27,0,3,3,60,28,1,1000,-2:-2,hex,show,fast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"