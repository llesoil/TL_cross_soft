#!/bin/sh

numb='1539'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.1 --psy-rd 4.2 --qblur 0.4 --qcomp 0.8 --vbv-init 0.3 --aq-mode 2 --b-adapt 0 --bframes 12 --crf 0 --keyint 270 --lookahead-threads 0 --min-keyint 21 --qp 30 --qpstep 5 --qpmin 3 --qpmax 67 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset veryslow --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,0.5,1.2,1.1,4.2,0.4,0.8,0.3,2,0,12,0,270,0,21,30,5,3,67,38,5,1000,-2:-2,hex,show,veryslow,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"