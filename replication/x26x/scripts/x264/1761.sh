#!/bin/sh

numb='1762'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.1 --psy-rd 4.8 --qblur 0.6 --qcomp 0.6 --vbv-init 0.1 --aq-mode 1 --b-adapt 1 --bframes 8 --crf 10 --keyint 210 --lookahead-threads 4 --min-keyint 27 --qp 40 --qpstep 4 --qpmin 4 --qpmax 65 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset medium --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,1.5,1.4,1.1,4.8,0.6,0.6,0.1,1,1,8,10,210,4,27,40,4,4,65,38,6,2000,-1:-1,umh,show,medium,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"