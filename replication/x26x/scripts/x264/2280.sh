#!/bin/sh

numb='2281'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 4.4 --qblur 0.5 --qcomp 0.8 --vbv-init 0.3 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 15 --keyint 260 --lookahead-threads 2 --min-keyint 29 --qp 30 --qpstep 5 --qpmin 1 --qpmax 61 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset medium --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,1.0,1.1,1.4,4.4,0.5,0.8,0.3,2,2,0,15,260,2,29,30,5,1,61,38,4,2000,1:1,dia,show,medium,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"