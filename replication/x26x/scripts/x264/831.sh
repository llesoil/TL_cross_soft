#!/bin/sh

numb='832'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 2.4 --qblur 0.6 --qcomp 0.7 --vbv-init 0.1 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 0 --keyint 250 --lookahead-threads 1 --min-keyint 26 --qp 40 --qpstep 3 --qpmin 3 --qpmax 66 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset veryslow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,0.0,1.4,1.4,2.4,0.6,0.7,0.1,1,0,4,0,250,1,26,40,3,3,66,18,3,1000,1:1,hex,show,veryslow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"