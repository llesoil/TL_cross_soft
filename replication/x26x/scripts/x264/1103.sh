#!/bin/sh

numb='1104'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 2.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.1 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 5 --keyint 240 --lookahead-threads 1 --min-keyint 26 --qp 50 --qpstep 4 --qpmin 3 --qpmax 67 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset slow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,0.5,1.0,1.2,2.6,0.5,0.6,0.1,3,1,14,5,240,1,26,50,4,3,67,18,4,2000,1:1,umh,show,slow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"