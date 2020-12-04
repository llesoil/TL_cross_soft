#!/bin/sh

numb='1720'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 3.0 --qblur 0.2 --qcomp 0.7 --vbv-init 0.9 --aq-mode 1 --b-adapt 0 --bframes 12 --crf 5 --keyint 260 --lookahead-threads 4 --min-keyint 27 --qp 40 --qpstep 3 --qpmin 4 --qpmax 66 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset veryslow --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,3.0,1.5,1.0,3.0,0.2,0.7,0.9,1,0,12,5,260,4,27,40,3,4,66,48,3,2000,1:1,dia,show,veryslow,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"