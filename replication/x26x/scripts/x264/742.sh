#!/bin/sh

numb='743'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 2.0 --qblur 0.4 --qcomp 0.6 --vbv-init 0.2 --aq-mode 3 --b-adapt 2 --bframes 8 --crf 35 --keyint 300 --lookahead-threads 2 --min-keyint 27 --qp 50 --qpstep 4 --qpmin 3 --qpmax 61 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset superfast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,3.0,1.5,1.4,2.0,0.4,0.6,0.2,3,2,8,35,300,2,27,50,4,3,61,38,5,2000,1:1,hex,show,superfast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"