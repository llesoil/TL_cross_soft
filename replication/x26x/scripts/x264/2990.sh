#!/bin/sh

numb='2991'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 3.4 --qblur 0.6 --qcomp 0.9 --vbv-init 0.6 --aq-mode 0 --b-adapt 2 --bframes 4 --crf 5 --keyint 250 --lookahead-threads 2 --min-keyint 23 --qp 40 --qpstep 5 --qpmin 0 --qpmax 67 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset veryfast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,2.5,1.2,1.0,3.4,0.6,0.9,0.6,0,2,4,5,250,2,23,40,5,0,67,28,1,2000,1:1,hex,show,veryfast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"